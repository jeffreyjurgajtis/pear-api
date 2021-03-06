require "rails_helper"

describe V1::EntriesController, type: :controller do
  let(:user) { create :user }
  let(:budget_sheet) { create :budget_sheet, user: user }
  let(:category) { create :category, budget_sheet: budget_sheet }

  before { set_auth_headers(user) }

  describe "GET index" do
    context "success" do
      it "returns status 200" do
        get :index, budget_sheet_id: budget_sheet.id
        expect(response).to have_http_status(200)
      end
    end

    context "forbidden" do
      it "returns status 403" do
        random_budget_sheet = create(:budget_sheet)

        get :index, budget_sheet_id: random_budget_sheet.id
        expect(response).to have_http_status(403)
      end
    end
  end

  describe "POST create" do
    context "success" do
      let(:valid_params) do
        {
          description: "Local Coffee",
          occurred_on: Time.zone.tomorrow,
          amount: 1212,
          category: category.id,
          budget_sheet: budget_sheet.id
        }
      end

      it "returns status 201" do
        post :create, entry: valid_params
        expect(response).to have_http_status 201
      end

      it "persists" do
        expect do
          post :create, entry: valid_params
        end.to change { Entry.count }.by 1
      end
    end

    context "failure" do
      let(:invalid_params) do
        {
          description: "Local Coffee",
          occurred_on: Time.zone.tomorrow,
          amount: nil,
          category: category.id,
          budget_sheet: budget_sheet.id
        }
      end

      it "returns status 400" do
        post :create, entry: invalid_params
        expect(response).to have_http_status 400
      end

      it "persists" do
        expect do
          post :create, entry: invalid_params
        end.to_not change { Entry.count }
      end
    end

    context "forbidden" do
      let(:random_budget_sheet) { create :budget_sheet }

      let(:params) do
        {
          description: "Local Coffee",
          occurred_on: Time.zone.tomorrow,
          amount: 1212,
          category: category.id,
          budget_sheet: random_budget_sheet.id
        }
      end

      it "returns status 403" do
        post :create, entry: params
        expect(response).to have_http_status 403
      end

      it "does not persist" do
        expect do
          post :create, entry: params
        end.to_not change { Entry.count }
      end
    end
  end

  describe "PUT update" do
    let(:entry) do
      create(:entry, category: category, budget_sheet: budget_sheet)
    end

    context "success" do
      let(:valid_params) do
        {
          description: "Local Coffee",
          occurred_on: Time.zone.tomorrow,
          amount: 1212,
          category: category.id,
          budget_sheet: budget_sheet.id
        }
      end

      it "returns status 200" do
        put :update, id: entry.id, entry: valid_params
        expect(response).to have_http_status 200
      end
    end

    context "failure" do
      it "returns status 400" do
        put :update, id: entry.id, entry: { amount: "" }
        expect(response).to have_http_status 400
      end
    end

    context "forbidden" do
      let!(:random_entry) { create :entry }

      it "returns status 403" do
        put :update, id: random_entry.id, entry: { amount: 20000 }
        expect(response).to have_http_status 403
      end
    end
  end

  describe "DELETE destroy" do
    context "success" do
      let!(:entry) do
        create(:entry, category: category, budget_sheet: budget_sheet)
      end

      it "returns status 204" do
        delete :destroy, id: entry.id
        expect(response).to have_http_status 204
      end

      it "deletes" do
        expect do
          delete :destroy, id: entry.id
        end.to change { Entry.count }.by -1
      end
    end

    context "forbidden" do
      let!(:random_entry) { create :entry }

      it "returns status 403" do
        delete :destroy, id: random_entry.id
        expect(response).to have_http_status 403
      end

      it "deletes" do
        expect do
          delete :destroy, id: random_entry.id
        end.to_not change { Entry.count }
      end
    end
  end
end
