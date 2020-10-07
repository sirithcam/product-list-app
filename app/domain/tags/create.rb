class Tags::Create
  include Interactor::Initializer

  initialize_with :title

  def run
    Tag.create(title: title)
  end
end
