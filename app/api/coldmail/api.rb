module Coldmail
  class API  < Grape::API
    rescue_from :all
    include Grape::Extensions::Hash::ParamBuilder
    version 'v1', using: :path, vendor: 'coldmail'
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers
    error_formatter :json, Grape::Formatter::ActiveModelSerializers
    prefix :api

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    helpers do
      def authenticated
        @user = User.find_by(authentication_token: (request.headers['Access-Token']))
      end

      def current_user
        @user
      end

     def letter_params
       letter_params = declared(params)[:letter]
       letter_params = letter_params.each { |key,value| letter_params.delete(key) if value.nil? }
     end
    end

    resource :letters do
      desc 'Returns letters for current user'
      get :index do
        current_user.letters
      end

      desc 'Show letter'
      params do
        requires :id, type: Integer
      end
      get ':id' do
        current_user.letters.find(params[:id])
      end

      desc 'Create letter'
      params do
        requires :letter, type: Hash do
          requires :email
          requires :url_site
          optional :comment
        end
      end
      post do
        current_user.letters.create!(letter_params)
      end

      desc 'Update letter'
      params do
        requires :letter, type: Hash do
          optional :comment
          optional :email
          optional :url_site
        end
      end
      put ':id' do
        current_user.letters.find(params[:id]).update(letter_params)
      end

      desc 'Delete letter'
      params do
        requires :id
      end
      delete ':id' do
        current_user.letters.find(params[:id]).destroy
      end

    end
  end
end
