class Hash
  def method_missing(name, *args)
    self[name] || super
  end
end
