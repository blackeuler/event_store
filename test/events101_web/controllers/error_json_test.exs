defmodule Events101Web.ErrorJSONTest do
  use Events101Web.ConnCase, async: true

  test "renders 404" do
    assert Events101Web.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Events101Web.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
