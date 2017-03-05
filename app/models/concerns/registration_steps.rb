module RegistrationSteps
  InfoStep = 1
  DocumentsStep = 2
  ModerationStep = 3

  STEPS = {
    InfoStep => 'Указание сведений',
    DocumentsStep => 'Загрузка документов',
    ModerationStep => 'Ожидание подтверждения'
  }

  def registration_step
    @registration_step ||=
      if persisted?
        if awaiting_review? || accepted? || rejected?
          ModerationStep
        else
          DocumentsStep
        end
      else
        InfoStep
      end
  end
end
