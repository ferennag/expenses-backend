module Pagination
  extend ActiveSupport::Concern

  DEFAULT_PAGE_SIZE = 50
  DEFAULT_ORDER_BY = :date
  DEFAULT_ORDER = :desc

  included do
    def allow_pagination
      # TODO add validation of these parameters
      approved_params = params.permit(:page, :page_size, :order_by, :order)
      @page = approved_params[:page] || 1
      @page_size = approved_params[:page_size] || DEFAULT_PAGE_SIZE
      @order_by = approved_params[:order_by] || DEFAULT_ORDER_BY
      @order = approved_params[:order] || DEFAULT_ORDER
    end
  end
end