(define-constant sbtc-contract 'SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token)
(define-constant interest-rate u5) ;; 0.5% interest per deposit period
(define-constant savings-info-not-found (err u1))
(define-constant locked-until-info-not-found (err u2))
(define-constant vault-still-active (err u3))
(define-constant goal-less-than-zero (err u4))
(define-constant lock-period-less-than-zero (err u5))
(define-constant group-closed (err u6))

;; (define-constant vault-still-active (err u3))
;; (define-constant err-invalid-caller (err u1))
;; Individual savings: Map of (user, depositId)  deposit struct
(define-map savings
  {
    user: principal,
    deposit-id: uint,
  }
  {
    amount: uint,
    locked-until: uint,
  }
)

;; Track user deposit counts
(define-map user-deposit-count
  { user: principal }
  { count: uint }
)

;; Group savings: group-id group info
(define-map groups
  { group-id: uint }
  {
    owner: principal,
    goal: uint,
    total-contributed: uint,
    lock-until: uint,
    is-closed: bool,
  }
)

;; Group membership: (group-id, member) contribution amount
(define-map group-contributions
  {
    group-id: uint,
    member: principal,
  }
  { amount: uint }
)

(define-data-var next-group-id uint u1)

(define-data-var next-personal-id uint u1)

;; #[allow(unchecked_data)]
(define-public (deposit
    (amount uint)
    (lock-period uint)
  )
  (let (
      (sender tx-sender)
      (user-count (map-get? user-deposit-count { user: sender }))
      (deposit-id (var-get next-personal-id))
    )
    (try! (contract-call? 'SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token
      transfer amount sender (as-contract tx-sender) none
    ))
    (map-set savings {
      user: sender,
      deposit-id: deposit-id,
    } {
      amount: amount,
      locked-until: (+ tenure-height lock-period),
    })
    (map-set user-deposit-count { user: sender } { count: (+ (default-to u0 (get count user-count)) u1) })
    (var-set next-personal-id (+ deposit-id u1))
    (ok true)
  )
)

;; #[allow(unchecked_data)]
(define-public (withdraw (deposit-id uint))
  (let (
      (sender tx-sender)
      (savings-info (map-get? savings {
        user: sender,
        deposit-id: deposit-id,
      }))
      (amount-saved (unwrap! (get amount savings-info) savings-info-not-found))
    )
    ;; tenure-height is block height 
    (asserts!
      (>= tenure-height
        (unwrap! (get locked-until savings-info) locked-until-info-not-found)
      )
      vault-still-active
    )
    (try! (contract-call? 'SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token
      transfer amount-saved (as-contract tx-sender) sender none
    ))
    (map-set savings {
      user: sender,
      deposit-id: deposit-id,
    } {
      amount: u0,
      locked-until: u0,
    })
    (ok true)
  )
)

;; -------------------------
;; GROUP SAVINGS
;; -------------------------
(define-public (create-group
    (goal uint)
    (lock-period uint)
  )
  (let ((gid (var-get next-group-id)))
    (asserts! (> goal u0) goal-less-than-zero)
    (asserts! (> lock-period u0) lock-period-less-than-zero)
    (map-set groups { group-id: gid } {
      owner: tx-sender,
      goal: goal,
      total-contributed: u0,
      lock-until: (+ tenure-height lock-period),
      is-closed: false,
    })
    (var-set next-group-id (+ gid u1))
    (ok gid)
  )
)

;; #[allow(unchecked_data)]
(define-public (contribute-to-group
    (group-id uint)
    (amount uint)
  )
  (let (
      (sender tx-sender)
      (some-group (unwrap! (map-get? groups { group-id: group-id }) (err u8)))
      (new-total (+ (get total-contributed some-group) amount))
      (current (default-to u0
        (get amount
          (map-get? group-contributions {
            group-id: group-id,
            member: tx-sender,
          })
        )))
    )
    (asserts! (not (get is-closed some-group)) group-closed)
    (asserts! (< tenure-height (get lock-until some-group)) vault-still-active)
    (try! (contract-call? 'SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token
      transfer amount sender (as-contract tx-sender) none
    ))
    (map-set group-contributions {
      group-id: group-id,
      member: tx-sender,
    } { amount: (+ current amount) }
    )
    (map-set groups { group-id: group-id } {
      owner: (get owner some-group),
      goal: (get goal some-group),
      total-contributed: new-total,
      lock-until: (get lock-until some-group),
      is-closed: false,
    })
    (ok true)
  )
)

;; #[allow(unchecked_data)]
(define-public (withdraw-group (group-id uint))
  (let (
      (sender tx-sender)
      (savings-info (map-get? group-contributions {
        group-id: group-id,
        member: sender,
      }))
      (savings-group-info (unwrap! (map-get? groups { group-id: group-id }) savings-info-not-found))
      (amount-saved (unwrap! (get amount savings-info) savings-info-not-found))
      (some-group (get owner savings-group-info))
    )
    (asserts! (>= tenure-height (get lock-until savings-group-info))
      vault-still-active
    )
    (try! (contract-call? 'SM3VDXK3WZZSA84XXFKAFAF15NNZX32CTSG82JFQ4.sbtc-token
      transfer amount-saved (as-contract tx-sender) sender none
    ))
    (map-delete group-contributions {
      group-id: group-id,
      member: tx-sender,
    })
    (map-set groups { group-id: group-id } {
      owner: (get owner savings-group-info),
      goal: (get goal savings-group-info),
      total-contributed: (get total-contributed savings-group-info),
      lock-until: (get lock-until savings-group-info),
      is-closed: true,
    })
    (ok true)
  )
)

;; -------------------------
;; READ FUNCTIONS
;; -------------------------

(define-read-only (get-user-deposit-count (user principal))
  (default-to u0 (get count (map-get? user-deposit-count { user: user })))
)

(define-read-only (get-deposit
    (user principal)
    (deposit-id uint)
  )
  (map-get? savings {
    user: user,
    deposit-id: deposit-id,
  })
)

(define-read-only (get-group (group-id uint))
  (map-get? groups { group-id: group-id })
)

(define-read-only (get-user-group-contribution
    (group-id uint)
    (user principal)
  )
  (map-get? group-contributions {
    group-id: group-id,
    member: user,
  })
)
