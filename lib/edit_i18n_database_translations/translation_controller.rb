module EditI18nDatabaseTranslations
  class TranslationController < ActionController::Base
    include EditI18nDatabaseTranslations::ControllerModule

    before_action :set_locale, only: [:admin]

    helper_method :show_images?

    def save
      create_or_update_translation(params[:value])
      render(json: {})

    end

    def admin
      @list_of_keys = []
      update_list_of_keys(prefix, allowed_translations)
      render template: 'edit_i18n_database_translations/admin.html.erb'
    end

    def upload
      save_file
      file_path = ['/sharing_images', random_file_name].join('/')
      create_or_update_translation(file_path)
      redirect_to params[:redirect_to]
    end

    private

    def create_or_update_translation(value)
      if translation
        translation.update(value: value)
      else
        Translation.create(locale: params[:locale],
                           key: prefix,
                           value: value)
      end
      I18n.reload!
    end

    def random_file_name
      return @random_file_name if @random_file_name
      @random_file_name = random_string +
                          File.extname(uploaded_io.original_filename)
    end

    def random_string
      (0...25).map { ('a'..'z').to_a[rand(26)] }.join
    end

    def save_file
      file_path = Rails.root.join('public', 'sharing_images',
                 random_file_name)
      File.open(file_path, 'wb') do |file|
        file.write(uploaded_io.read)
      end
    end

    def uploaded_io
      params[:picture]
    end

    def are_you_i18n_editor?
      true
    end

    def update_list_of_keys(prefix, x)
      if x.is_a? Hash
        if (not prefix.empty?)
            prefix += "."
        end
        x.each {|key, value|
          update_list_of_keys(prefix + key.to_s, value)
        }
      else
        if show_images?
          return unless EditI18nDatabaseTranslations.config.check_images_proc.call(prefix)
        end
        @list_of_keys.push(prefix)
      end
    end

    def translation
      @translation ||= Translation.where(key: params[:key], locale: params[:locale]).first
    end

    def allowed_keys
      EditI18nDatabaseTranslations.config.allowed_keys
    end

    def all_translations
      I18n.t('.')
    end

    def allowed_translations
      if show_images?
        return all_translations
      end

      if !prefix.empty?
        I18n.t(prefix)
      else
        all_translations.select { |key, _| allowed_keys.include?(key) }
      end
    end

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def prefix
      params[:key].to_s
    end

    def show_images?
      EditI18nDatabaseTranslations.config.show_images_tab && params[:images]
    end
  end
end
