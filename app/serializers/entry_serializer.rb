class EntrySerializer < ActiveModel::Serializer
  attributes :id, :category_id, :description, :amount, :occurred_on
end