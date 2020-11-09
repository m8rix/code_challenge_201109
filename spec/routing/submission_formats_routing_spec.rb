require "rails_helper"

RSpec.describe SubmissionFormatsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/submission_formats").to route_to("submission_formats#index")
    end

    it "routes to #new" do
      expect(get: "/submission_formats/new").to route_to("submission_formats#new")
    end

    it "routes to #show" do
      expect(get: "/submission_formats/1").to route_to("submission_formats#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/submission_formats/1/edit").to route_to("submission_formats#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/submission_formats").to route_to("submission_formats#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/submission_formats/1").to route_to("submission_formats#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/submission_formats/1").to route_to("submission_formats#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/submission_formats/1").to route_to("submission_formats#destroy", id: "1")
    end
  end
end
