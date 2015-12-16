module Moip::Assinaturas
  class Invoice

    class << self

      def list(subscription_code, opts={})
        response = Moip::Assinaturas::Client.list_invoices(subscription_code, opts)
        hash     = JSON.load(response.body).with_indifferent_access

        case response.code
        when 200
          return {
            success:  true,
            invoices: hash[:invoices]
          }
        when 401
          raise(UnauthorizedError, "Você não tem permissão de utilizar o assinaturas")
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

      def details(id, opts={})
        response = Moip::Assinaturas::Client.details_invoice(id, opts)
        hash     = JSON.load(response.body)
        hash     = hash.with_indifferent_access if hash

        case response.code
        when 200
          return {
            success:  true,
            invoice:  hash
          }
        when 404
          return {
            success: false,
            message: 'not found'
          }
        when 401
          raise(UnauthorizedError, "Você não tem permissão de utilizar o assinaturas")
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

      def retry(id, opts = {})
        response = Moip::Assinaturas::Client.retry_invoice(id, opts)
        hash     = JSON.load response.body
        hash     = hash.with_indifferent_access if hash

        case response.code
        when 200
          return {
            success:  true
          }
        when 400
          return {
            success: false,
            message: hash['message'],
            errors:  hash['errors']
          }
        when 401
          raise(UnauthorizedError, "Você não tem permissão de utilizar o assinaturas")
        else
          raise(WebServerResponseError, "Ocorreu um erro no retorno do webservice")
        end
      end

    end
  end
end
