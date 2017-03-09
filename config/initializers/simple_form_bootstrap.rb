# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.error_notification_class = 'alert alert-danger'
  config.button_class = 'btn btn-primary'
  config.boolean_label_class = nil

  config.wrappers :vertical_form, tag: 'div', class: 'form-group', error_class: 'has-danger' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'form-control-label'

    b.use :input, class: 'form-control'
    b.use :error, wrap_with: { tag: 'span', class: 'form-control-feedback' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'form-control-hint text-muted' }
  end

  config.wrappers :custom_file, tag: 'div', class: 'form-group', error_class: 'has-danger' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'form-control-label'

    b.wrapper tag: 'label', class: 'custom-file' do |ba|
      ba.use :input, class: 'custom-file-input'
      # ba.use :tag, tag: :span, class: 'custom-file-control'
      ba.wrapper tag: :span, class: 'custom-file-control' do
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'form-control-feedback' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'form-control-hint text-muted' }
    end
  end

  config.wrappers :custom_checkbox, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    # b.use :label, class: 'control-label' # col-sm-3

    b.optional :label
    b.wrapper tag: 'label', class: 'custom-control custom-checkbox' do |ba| # col-sm-9
      ba.use :input, class: 'custom-control-input'
      ba.wrapper tag: :span, class: 'custom-control-indicator' do
      end
      #b.use :label, tag: :span, class: 'custom-control-description'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      # ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end


  config.wrappers :vertical_file_input, tag: 'div', class: 'form-group', error_class: 'has-danger' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'form-control-label'

    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'form-control-feedback' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'form-control-hint text-muted' }
  end

  config.wrappers :vertical_boolean, tag: 'div', class: 'form-group', error_class: 'has-danger' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'checkbox' do |ba|
      ba.use :label_input
    end

    b.use :error, wrap_with: { tag: 'span', class: 'form-control-feedback' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'form-control-hint text-muted' }
  end

  config.wrappers :vertical_radio, tag: 'div', class: 'form-group', error_class: 'has-danger' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'form-control-label'
    b.use :input, class: 'custom-control-input'
    b.use :error, wrap_with: { tag: 'span', class: 'form-control-feedback' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'form-control-hint text-muted' }
  end

  config.wrappers :vertical_radio_and_checkboxes, tag: 'div', class: 'form-group', error_class: 'has-danger' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'form-control-label'
    b.use :input
    b.use :error, wrap_with: { tag: 'span', class: 'form-control-feedback' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'form-control-hint text-muted' }
  end

  config.wrappers :horizontal_form, tag: 'div', class: 'form-group', error_class: 'has-danger' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'col-sm-3 form-control-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'form-control-feedback' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'form-control-hint text-muted' }
    end
  end

  config.wrappers :horizontal_file_input, tag: 'div', class: 'form-group', error_class: 'has-danger' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :readonly
    b.use :label, class: 'col-sm-3 form-control-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'form-control-feedback' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'form-control-hint text-muted' }
    end
  end

  config.wrappers :horizontal_boolean, tag: 'div', class: 'form-group', error_class: 'has-danger' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper tag: 'div', class: 'col-sm-offset-3 col-sm-9' do |wr|
      wr.wrapper tag: 'div', class: 'checkbox' do |ba|
        ba.use :label_input
      end

      wr.use :error, wrap_with: { tag: 'span', class: 'form-control-feedback' }
      wr.use :hint,  wrap_with: { tag: 'p', class: 'form-control-hint text-muted' }
    end
  end

  config.wrappers :horizontal_radio_and_checkboxes, tag: 'div', class: 'form-group', error_class: 'has-danger' do |b|
    b.use :html5
    b.optional :readonly

    b.use :label, class: 'col-sm-3 form-control-label'

    b.wrapper tag: 'div', class: 'col-sm-9' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'form-control-feedback' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'forn-control-hint text-muted' }
    end
  end

  config.wrappers :inline_form, tag: 'div', class: 'form-group', error_class: 'has-danger' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'sr-only'

    b.use :input, class: 'form-control'
    b.use :error, wrap_with: { tag: 'span', class: 'form-control-feedback' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'form-control-hint text-muted' }
  end

  config.wrappers :custom_select, tag: 'div', class: 'form-group', error_class: 'has-danger' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'form-control-label'
    b.use :input, class: 'custom-select form-control'
    b.use :error, wrap_with: { tag: 'span', class: 'form-control-feedback' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'form-control-hint text-muted' }
  end

  config.wrappers :multi_select, tag: 'div', class: 'form-group', error_class: 'has-danger' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'form-control-label'
    b.wrapper tag: 'div', class: 'form-inline' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'form-control-feedback' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'form-control-hint text-muted' }
    end
  end


	# append and prepend https://gist.github.com/chunlea/11125126/
  config.wrappers :vertical_input_group, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'control-label'

    b.wrapper tag: 'div' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |append| # col-sm-12
        append.use :input, class: 'form-control'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :horizontal_input_group, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'control-label' # col-sm-3

    b.wrapper tag: 'div' do |ba| # col-sm-9
      ba.wrapper tag: 'div', class: 'input-group' do |append| # col-sm-12
        append.use :input, class: 'form-control'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  # Wrappers for forms and inputs using the Bootstrap toolkit.
  # Check the Bootstrap docs (http://getbootstrap.com)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :vertical_form
  config.wrapper_mappings = {
    select: :custom_select,
    check_boxes: :vertical_radio_and_checkboxes,
    radio_buttons: :vertical_radio_and_checkboxes,
    file: :custom_file,
    boolean: :horizontal_boolean,
    datetime: :multi_select,
    date: :multi_select,
    time: :multi_select
  }
end
