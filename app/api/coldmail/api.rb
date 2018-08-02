module Coldmail
  class API  < Grape::API
    include Grape::Extensions::Hash::ParamBuilder
    version 'v1', using: :path, vendor: 'coldmail'
    format :json
    prefix :api

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    helpers do
      def authenticated
        request.headers['Access-Token'] && @user = User.find_by_authentication_token(request.headers['Access-Token'])
      end

      def current_user
        @user
      end
    end

    resource :letters do
      desc 'Returns letters of the current user'
      get :index do
        authenticated
        current_user.letters
      end

      desc 'Show letter'
      params do
        requires :id, type: Integer
      end
      get ':id' do
        authenticated
        current_user.letters.find(params[:id])
      end

      desc 'Create letter'
      params do
        requires :letter, type: Hash do
          requires :comment
          requires :email
          requires :url_site
        end
      end
      post do
        authenticated
        byebug
        { 'declared_params' => declared(params) }
        current_user.letters.create!(declared(params)[:letter])
      end

      desc 'Update letter'
      params do
        build_with Grape::Extensions::Hash::ParamBuilder
        requires :letter, type: Hash do
          optional :comment
          optional :email
          optional :url_site
        end
      end
      put ':id' do
        authenticated
        { 'declared_params' => declared(params) }
        letter_params = declared(params)[:letter]
        letter_params = letter_params.each { |key,value| letter_params.delete(key) if value.nil? }
        current_user.letters.find(params[:id]).update(letter_params)
      end

      desc 'Delete letter'
      params do
        requires :id
      end
      delete ':id' do
        authenticated
        current_user.letters.find(params[:id]).destroy
      end

    end
  end
end
