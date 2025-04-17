;; Cost Allocation Contract
;; Distributes expenses across hotel departments

;; Department expense structure
(define-map department-expenses
  { department: (string-ascii 20) }
  {
    laundry-cost: uint,
    replacement-cost: uint,
    total-items: uint
  }
)

;; Record laundry expense for a department
(define-public (record-laundry-expense (department (string-ascii 20)) (cost uint))
  (let
    (
      (current-expenses (default-to
        { laundry-cost: u0, replacement-cost: u0, total-items: u0 }
        (map-get? department-expenses { department: department })))
    )
    (map-set department-expenses
      { department: department }
      (merge current-expenses {
        laundry-cost: (+ (get laundry-cost current-expenses) cost)
      })
    )
    (ok true)
  )
)

;; Record replacement expense for a department
(define-public (record-replacement-expense (department (string-ascii 20)) (cost uint))
  (let
    (
      (current-expenses (default-to
        { laundry-cost: u0, replacement-cost: u0, total-items: u0 }
        (map-get? department-expenses { department: department })))
    )
    (map-set department-expenses
      { department: department }
      (merge current-expenses {
        replacement-cost: (+ (get replacement-cost current-expenses) cost)
      })
    )
    (ok true)
  )
)

;; Add item to department inventory count
(define-public (add-department-item (department (string-ascii 20)))
  (let
    (
      (current-expenses (default-to
        { laundry-cost: u0, replacement-cost: u0, total-items: u0 }
        (map-get? department-expenses { department: department })))
    )
    (map-set department-expenses
      { department: department }
      (merge current-expenses {
        total-items: (+ (get total-items current-expenses) u1)
      })
    )
    (ok true)
  )
)

;; Remove item from department inventory count
(define-public (remove-department-item (department (string-ascii 20)))
  (let
    (
      (current-expenses (default-to
        { laundry-cost: u0, replacement-cost: u0, total-items: u0 }
        (map-get? department-expenses { department: department })))
    )
    (asserts! (> (get total-items current-expenses) u0) (err u404))

    (map-set department-expenses
      { department: department }
      (merge current-expenses {
        total-items: (- (get total-items current-expenses) u1)
      })
    )
    (ok true)
  )
)

;; Get department expenses
(define-read-only (get-department-expenses (department (string-ascii 20)))
  (default-to
    { laundry-cost: u0, replacement-cost: u0, total-items: u0 }
    (map-get? department-expenses { department: department })
  )
)

;; Calculate cost per item for a department
(define-read-only (get-cost-per-item (department (string-ascii 20)))
  (let
    (
      (expenses (get-department-expenses department))
      (total-cost (+ (get laundry-cost expenses) (get replacement-cost expenses)))
      (items (get total-items expenses))
    )
    (if (> items u0)
      (/ total-cost items)
      u0
    )
  )
)
