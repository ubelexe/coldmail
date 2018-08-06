module Coldmail
  class API  < Grape::API
    rescue_from :all
    include Grape::Extensions::Hash::ParamBuilder
    version 'v1', using: :path, vendor: 'coldmail'
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers
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

      desc 'Search letter by email'
      params do
        optional :q
      end
      get :search do
        Letter.find_by!(email: params[:q])
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

      desc 'Change AASM state for current letter'
      params do
        requires :aasm_transition, type: String, values: ['run!', 'sleep!', 'done!']
      end
      put 'aasm_transition/:id' do
        letter = current_user.letters.find(params[:id])
        letter.send(params[:aasm_transition])
        return letter
      end

      desc 'Delete letter'
      params do
        requires :id, type: Integer
      end
      delete ':id' do
        current_user.letters.find(params[:id]).destroy
      end

    end
  end
end
