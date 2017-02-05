module RegistrationSteps
  InfoStep = 1
  DocumentsStep = 2
  ModerationStep = 3
  DoneStep = 4

  STEPS = {
    InfoStep => 'Указание сведений',
    DocumentsStep => 'Загрузка документов',
    ModerationStep => 'Ожидание подтверждения'
  }

  def registration_step
    @registration_step ||=
      if !persisted?
        InfoStep
      elsif !all_documents_loaded?
        DocumentsStep
      elsif waits_review?
        ModerationStep
      else
        DoneStep
      end
  end
end
