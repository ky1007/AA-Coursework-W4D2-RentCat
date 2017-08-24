class CatRentalRequest < ApplicationRecord
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: %w(APPROVED PENDING DENIED), message: "Invalid status!" }
  validate :does_not_overlap_approved_request # message: "This cat is already booked!"

  belongs_to :cat,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: :Cat

  def approve!
    if self.status == "PENDING"
      CatRentalRequest.transaction do
        self.status = "APPROVED"
        overlapping_requests.each do |request|
          request.status = "DENIED"
        end
      end
    end
  end

  def deny!
    self.status = "DENIED"
  end

  def pending?
    self.status == "PENDING"
  end

  def overlapping_requests
    CatRentalRequest
      .where.not(id: self.id)
      .where(cat_id: cat_id)
      .where(<<-SQL, start_date: start_date, end_date: end_date)
         NOT( (start_date > :end_date) OR (end_date < :start_date) )
      SQL
  end

  def overlapping_approved_requests
    overlapping_requests
      .where("status = 'APPROVED'")
  end

  def does_not_overlap_approved_request
    overlapping_approved_requests.exists?
  end
end
