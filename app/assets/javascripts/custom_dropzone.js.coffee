#= require dropzone
#
Dropzone.autoDiscover = false

Dropzone.prototype.defaultOptions.dictDefaultMessage = "Переместите сюда файлы для загрузки"
Dropzone.prototype.defaultOptions.dictFallbackMessage = "Your browser does not support drag'n'drop file uploads."
Dropzone.prototype.defaultOptions.dictFallbackText = "Please use the fallback form below to upload your files like in the olden days."
Dropzone.prototype.defaultOptions.dictFileTooBig = "File is too big ({{filesize}}MiB). Max filesize: {{maxFilesize}}MiB."
Dropzone.prototype.defaultOptions.dictInvalidFileType = "Файлы с таким разрешением загружать нельзя"
Dropzone.prototype.defaultOptions.dictResponseError = "Server responded with {{statusCode}} code."
Dropzone.prototype.defaultOptions.dictCancelUpload = "Остановить загрузку"
Dropzone.prototype.defaultOptions.dictCancelUploadConfirmation = "Действительно остановить загрузку?"
Dropzone.prototype.defaultOptions.dictRemoveFile = 'Удалить'
Dropzone.prototype.defaultOptions.dictMaxFilesExceeded = "You can not upload any more files."

removedFileHandler = (file) ->
  company_id = $('form[data-company-id]').data('company-id')
  console.debug? 'company_id', company_id

  $.ajax
    type: 'DELETE'
    url: "/companies/#{company_id}/company_documents/delete_by_name"
    data:
      name: file.name
    xhrFields:
      withCredentials: true

  el = file.previewElement
  if el
    # el.parentNode.removeChild _ref
    $(el).fadeOut 'normal', -> $(@).remove()

  return true

  # return (_ref = file.previewElement) != null ? _ref.parentNode.removeChild(file.previewElement) : void 0;        


$('[data-dropzone]').dropzone
  acceptedFiles: ".jpeg,.jpg,.png,.gif,.tiff"
  addRemoveLinks: true
  removedfile: removedFileHandler
  init: ->
    @on '!addedfile', (file) ->
      debugger
      removeButton = Dropzone.createElement '<button class="dz-remove" data-dz-remove data-docoument-id=1>Удалить</button>'
      debugger

      _this = @

      removeButton.addEventListener "click", (e) ->
        e.preventDefault()
        e.stopPropagation()

        _this.removeFile(file)
#
      file.previewElement.appendChild(removeButton)

