module EditI18nDatabaseTranslations
  class TranslationController < ActionController::Base
    include EditI18nDatabaseTranslations::ControllerModule

    before_action :set_locale, only: [:admin]

    def save
      if translation
        translation.update(value: params[:value])
      else
        Translation.create(locale: I18n.locale,
                           key: params[:key],
                           value: params[:value])
      end
      I18n.reload!
      return render(json: {})
    end

    def admin
      @list_of_keys = []
      update_list_of_keys('', allowed_translations)
      render template: 'edit_i18n_database_translations/admin.html.erb'
    end

    private

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
      all_translations.select { |key, _| allowed_keys.include?(key) }
    end

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end
  end
end
