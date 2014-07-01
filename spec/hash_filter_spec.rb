require "spec_helper"

describe HashFilter do
  let(:subject) { HashFilter }
  let(:filter) { subject.new }
  let(:plain_hash) { Hash.new }

  describe "integration" do
    describe "example" do
      let(:filter) do
        HashFilter.new do
          delete "foo"
          delete /bar/
          rename "bad", "good"
          rename /^yoda (.*)/, '\1 yoda'
        end
      end
      let(:plain_hash) { Hash[
        "foo" => :yes,
        "barfrau" => "blond",
        "wunderbar" => true,
        "bad" => "taste",
        "yoda says" => "hello",
        "yoda sees" => "you"
      ]}

      it "works" do
        assert_hash \
          "good" => "taste",
          "says yoda" => "hello",
          "sees yoda" => "you"
      end
    end
  end

  describe "delete" do
    let(:plain_hash) { Hash["key" => "value"] }

    it "deletes by string" do
      filter.delete "key"
      assert_hash
    end

    it "deletes by regex" do
      filter.delete /^key/
      assert_hash
    end

    it "misses" do
      filter.delete /^ey/
      filter.delete :key
      filter.delete "KEY"
      assert_hash plain_hash
    end

    it "does not modify original plain_hash" do
      filter.delete "key"
      assert_hash
      assert_equal 1, plain_hash.size
    end
  end

  describe "rename" do
    let(:plain_hash) { Hash["cards/1.jpg" => "path", "cards/UK/1.jpg" => "UK/path"] }

    it "deletes by string" do
      filter.rename "cards/1.jpg", "cards/UK/1.jpg"
      assert_hash "cards/UK/1.jpg" => "path"
    end

    it "delets by regexp" do
      filter.rename %r{cards/UK/(\d+\.jpg)}, 'cards/\1'
      assert_hash "cards/1.jpg" => "UK/path"
    end
  end

  describe "inject" do
    let(:filter) do
      filter1 = subject.new do
        delete /foo/
        delete /FOO/
      end
      filter2 = subject.new { rename /bar/, "baz" }

      subject.new do
        inject filter1
        inject filter2
      end
    end

    let(:plain_hash) { Hash[
      "foo" => 1,
      "FOO" => 2,
      "bar" => 3
    ] }

    it "injects operations from other filters" do
      assert_hash "baz" => 3
    end
  end

  private

  def assert_hash(expected={})
    actual = filter.apply plain_hash
    assert_equal expected, actual
  end
end
