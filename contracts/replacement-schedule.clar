;; Replacement Scheduling Contract
;; Manages retirement of worn items

;; Define replacement thresholds
(define-constant MAX_WASH_CYCLES u50)
(define-constant MAX_AGE_BLOCKS u52560) ;; Approximately 1 year in blocks

;; Replacement request structure
(define-map replacement-requests
  { item-id: uint }
  {
    request-date: uint,
    reason: (string-ascii 50),
    approved: bool,
    processed: bool
  }
)

;; Request replacement for an item
(define-public (request-replacement (item-id uint) (reason (string-ascii 50)))
  (begin
    (map-set replacement-requests
      { item-id: item-id }
      {
        request-date: block-height,
        reason: reason,
        approved: false,
        processed: false
      }
    )
    (ok true)
  )
)

;; Approve replacement request
(define-public (approve-replacement (item-id uint))
  (let
    (
      (request (unwrap! (map-get? replacement-requests { item-id: item-id }) (err u404)))
    )
    (map-set replacement-requests
      { item-id: item-id }
      (merge request { approved: true })
    )
    (ok true)
  )
)

;; Mark replacement as processed
(define-public (process-replacement (item-id uint))
  (let
    (
      (request (unwrap! (map-get? replacement-requests { item-id: item-id }) (err u404)))
    )
    ;; Check if request is approved
    (asserts! (get approved request) (err u403))

    (map-set replacement-requests
      { item-id: item-id }
      (merge request { processed: true })
    )
    (ok true)
  )
)

;; Check if item needs replacement based on age
(define-read-only (needs-replacement-by-age (item-id uint) (purchase-date uint))
  (> (- block-height purchase-date) MAX_AGE_BLOCKS)
)

;; Check if item needs replacement based on wash cycles
(define-read-only (needs-replacement-by-cycles (wash-count uint))
  (>= wash-count MAX_WASH_CYCLES)
)

;; Get replacement request details
(define-read-only (get-replacement-request (item-id uint))
  (map-get? replacement-requests { item-id: item-id })
)
