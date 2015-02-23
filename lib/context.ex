defprotocol Context do

  # @spec wrap(term) :: t
  # def wrap(value)

  @spec unwrap!(t) :: term
  def unwrap!(value)
end
