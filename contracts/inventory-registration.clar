;; Inventory Registration Contract
;; Records details of hotel textiles

(define-data-var last-item-id uint u0)

;; Define item types
(define-constant TOWEL u1)
(define-constant BED_SHEET u2)
(define-constant PILLOW_CASE u3)
(define-constant BATH_ROBE u4)

;; Define item status
(define-constant STATUS_ACTIVE u1)
(define-constant STATUS_INACTIVE u2)

;; Item structure
(define-map items
  { item-id: uint }
  {
    item-type: uint,
    purchase-date: uint,
    department: (string-ascii 20),
    status: uint,
    cost: uint
  }
)

;; Register a new item
(define-public (register-item (item-type uint) (department (string-ascii 20)) (cost uint))
  (let
    (
      (new-id (+ (var-get last-item-id) u1))
    )
    (var-set last-item-id new-id)
    (map-set items
      { item-id: new-id }
      {
        item-type: item-type,
        purchase-date: block-height,
        department: department,
        status: STATUS_ACTIVE,
        cost: cost
      }
    )
    (ok new-id)
  )
)

;; Get item details
(define-read-only (get-item (item-id uint))
  (map-get? items { item-id: item-id })
)

;; Update item status
(define-public (update-item-status (item-id uint) (new-status uint))
  (let
    (
      (item (unwrap! (map-get? items { item-id: item-id }) (err u404)))
    )
    (map-set items
      { item-id: item-id }
      (merge item { status: new-status })
    )
    (ok true)
  )
)

;; Update item department
(define-public (update-item-department (item-id uint) (new-department (string-ascii 20)))
  (let
    (
      (item (unwrap! (map-get? items { item-id: item-id }) (err u404)))
    )
    (map-set items
      { item-id: item-id }
      (merge item { department: new-department })
    )
    (ok true)
  )
)
