module Burpple
  module Exceptions
    class BurppleError < StandardError
      attr_accessor :status, :type, :httpcode
      def initialize(status, type, httpcode, message)
        super(message)
        self.status = status
        self.type   = type
        self.httpcode = httpcode
      end
    end

    ########
    class AuthError < BurppleError
      def initialize(message = 'auth error')
        super(:auth_error, "Auth Error", 401, message)
      end
    end
    class ExistingError < BurppleError
      def initialize(message = 'exsiting error')
        super(:existing_error, "Existing Error", 406, message)
      end
    end
    class DuplicateError < BurppleError
      def initialize(message = 'conflict error')
        super(:conflict_error, "Conflict Error", 409, message)
      end
    end
    class ConflictError < BurppleError
      def initialize(message = 'conflict error')
        super(:conflict_error, "Conflict Error", 409, message)
      end
    end
    class ForbiddenError < BurppleError
      def initialize(message = 'something wrong please try again')
        super(:forbidden, "Forbidden", 403, message)
      end
    end
    class BadRequestError < BurppleError
      def initialize(message = '')
        super(:bad_request, "Bad Request", 400, message)
      end
    end
    class NotFoundError < BurppleError
      def initialize(message = '')
        super(:not_found, "Not Found", 404, message)
      end
    end

    class RedeemError < BurppleError
      def initialize(message = 'Already Redeemed')
        super(:existing_error, 'Existing Error', 406, message)
      end
    end

    class RedeemExistsError < BurppleError
      def initialize(message = 'Invalid QR code')
        super(:existing_error, 'Existing Error', 404, message)
      end
    end

    class RedeemActiveError < BurppleError
      def initialize(message = 'The deal is not available for redemption yet')
        super(:existing_error, 'Forbidden Error', 403, message)
      end
    end

  end
end
