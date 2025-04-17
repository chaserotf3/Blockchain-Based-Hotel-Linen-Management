;; Laundry Tracking Contract
;; Monitors cleaning cycles and processing

(define-data-var last-cycle-id uint u0)

;; Define laundry status
(define-constant STATUS_PENDING u1)
(define-constant STATUS_IN_PROGRESS u2)
(define-constant STATUS_COMPLETED u3)

;; Laundry cycle structure
(define-map laundry-cycles
  { cycle-id: uint }
  {
    start-date: uint,
    end-date: uint,
    status: uint,
    batch-size: uint,
    processor: (string-ascii 20)
  }
)

;; Items in laundry cycle
(define-map cycle-items
  { cycle-id: uint, item-id: uint }
  { processed: bool }
)

;; Start a new laundry cycle
(define-public (start-laundry-cycle (processor (string-ascii 20)))
  (let
    (
      (new-id (+ (var-get last-cycle-id) u1))
    )
    (var-set last-cycle-id new-id)
    (map-set laundry-cycles
      { cycle-id: new-id }
      {
        start-date: block-height,
        end-date: u0,
        status: STATUS_PENDING,
        batch-size: u0,
        processor: processor
      }
    )
    (ok new-id)
  )
)

;; Add item to laundry cycle
(define-public (add-item-to-cycle (cycle-id uint) (item-id uint))
  (let
    (
      (cycle (unwrap! (map-get? laundry-cycles { cycle-id: cycle-id }) (err u404)))
    )
    ;; Check if cycle is still pending
    (asserts! (is-eq (get status cycle) STATUS_PENDING) (err u403))

    ;; Add item to cycle
    (map-set cycle-items
      { cycle-id: cycle-id, item-id: item-id }
      { processed: false }
    )

    ;; Update batch size
    (map-set laundry-cycles
      { cycle-id: cycle-id }
      (merge cycle { batch-size: (+ (get batch-size cycle) u1) })
    )

    (ok true)
  )
)

;; Start processing cycle
(define-public (start-processing (cycle-id uint))
  (let
    (
      (cycle (unwrap! (map-get? laundry-cycles { cycle-id: cycle-id }) (err u404)))
    )
    ;; Check if cycle is pending
    (asserts! (is-eq (get status cycle) STATUS_PENDING) (err u403))

    ;; Update cycle status
    (map-set laundry-cycles
      { cycle-id: cycle-id }
      (merge cycle { status: STATUS_IN_PROGRESS })
    )

    (ok true)
  )
)

;; Complete laundry cycle
(define-public (complete-cycle (cycle-id uint))
  (let
    (
      (cycle (unwrap! (map-get? laundry-cycles { cycle-id: cycle-id }) (err u404)))
    )
    ;; Check if cycle is in progress
    (asserts! (is-eq (get status cycle) STATUS_IN_PROGRESS) (err u403))

    ;; Update cycle status and end date
    (map-set laundry-cycles
      { cycle-id: cycle-id }
      (merge cycle {
        status: STATUS_COMPLETED,
        end-date: block-height
      })
    )

    (ok true)
  )
)

;; Get cycle details
(define-read-only (get-cycle (cycle-id uint))
  (map-get? laundry-cycles { cycle-id: cycle-id })
)

;; Check if item is in cycle
(define-read-only (is-item-in-cycle (cycle-id uint) (item-id uint))
  (is-some (map-get? cycle-items { cycle-id: cycle-id, item-id: item-id }))
)
