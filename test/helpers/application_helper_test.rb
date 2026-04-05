require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "flash_class returns notice styling" do
    assert_equal "border-emerald-200 bg-emerald-50 text-emerald-900", flash_class(:notice)
  end

  test "flash_class returns alert styling" do
    assert_equal "border-rose-200 bg-rose-50 text-rose-900", flash_class(:alert)
  end

  test "flash_class returns default styling" do
    assert_equal "border-stone-200 bg-white text-stone-900", flash_class(:anything_else)
  end
end
