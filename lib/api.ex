defmodule Api do
  use Tesla
  use Memoize

  plug(Tesla.Middleware.BaseUrl, "https://adventofcode.com/2022/day/")

  plug(Tesla.Middleware.Headers, [
    {"cookie",
     "session=53616c7465645f5f0fd80ac0b1d5daffa43a9b4d8ad6fdac87b2b44cb7803763f8376f6e088c8efb96b1273c424e6d2a97178f7e10b73b2cda0dfa478b35a6fa"}
  ])

  defmemo get_input(day) do
    {:ok, response} = get("#{day}/input")
    response.body
  end
end
