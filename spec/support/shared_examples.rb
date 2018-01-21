RSpec.shared_examples "renders index" do
  it { expect(response).to be_success }
  it { expect(subject).to render_template(:index) }
end

RSpec.shared_examples "renders new" do
  it { expect(response).to be_success }
  it { expect(subject).to render_template(:new) }
end

RSpec.shared_examples "without required attributes it redirects back to form" do |attributes, action|
  attributes.each do |attribute|
    context "without #{attribute.to_s}" do
      before do
        params[:bookmark][attribute] = nil
        post action, params: params
      end

      template = case action
        when :create
          "new"
        when :update
          "edit"
      end

      it_behaves_like "redirects to #{template}"
    end
  end
end

RSpec.shared_examples "with invalid url it redirects back to form" do |action|
  before do
    params[:bookmark][:url] = "abcdef"
    post action, params: params
  end

  template = case action
    when :create
      "new"
    when :update
      "edit"
  end

  it_behaves_like "redirects to #{template}"
end

RSpec.shared_examples "redirects to new" do |path|
  it { expect(response).to be_redirect }
  it { expect(response).to redirect_to(new_bookmark_path) }
end

RSpec.shared_examples "redirects to edit" do
  it { expect(response).to be_redirect }
  it { expect(response).to redirect_to(edit_bookmark_path) }
end

RSpec.shared_examples "redirects to dashboard" do
  it { expect(response).to be_redirect }
  it { expect(response).to redirect_to(dashboard_path) }
end

RSpec.shared_examples "redirects to login" do
  it { expect(response).to be_redirect }
  it { expect(response).to redirect_to(login_path) }
end

RSpec.shared_examples "assigns tags to bookmark" do |tag_names, tag_count|
  it { expect(Bookmark.last.tags.count).to eq tag_count }
  it { expect(Bookmark.last.tags.map(&:name)).to eq tag_names }
end

RSpec.shared_examples "ensures there is only one tag" do |tag_name|
  it { expect(Tag.count).to eq 1 }
  it { expect(Tag.all.map(&:name)).to eq [tag_name] }
end

RSpec.shared_examples "displays flash message" do |type, message|
  it { expect(flash[type]).to eq message}
end

RSpec.shared_examples "is not valid without required attributes" do |attributes|
  attributes.each do |attribute|
    it "is not valid without #{attribute}" do
      subject[attribute] = nil
      expect(subject).to_not be_valid
    end
  end
end

RSpec.shared_examples "is valid with correct attributes" do
  it { expect(subject).to be_valid }
end
