class Virtual < Product
  # Tipo de producto fisico/tangible

  validate :without_dimentions

  def without_dimentions
    if dimention.present?
      errors.add(:dimention, "virtual product can't have dimentions data")
    end
  end
end
