json.array!(@recent) do |rating|
  json.extract! rating, :id, :score, :beer
end