class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/libkrun/libkrun"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "303d765096fc28a7c31184a262fa8a9ed759c1ab6f156fe9b037b2d3f4931e25"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/libkrun/homebrew-krun/releases/download/libkrun-1.19.1"
    sha256 cellar: :any, arm64_tahoe:   "b2aa27f4826c8a2044fceb0ed01553581f54e0c4b03648a1e0df5997055aef6b"
    sha256 cellar: :any, arm64_sequoia: "27a51bae1a6e2c91bcdd92f508d21e56c3c75563117b06284982e394693598b1"
  end

  depends_on "lld" => :build
  depends_on "rust" => :build
  # Upstream only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "dtc"
  depends_on "libepoxy"
  depends_on "libkrunfw"
  depends_on "virglrenderer"
  depends_on "xz"

  def install
    system "make", "BLK=1", "NET=1", "GPU=1", "TIMESYNC=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libkrun.h>
      int main()
      {
         int c = krun_create_ctx();
         return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lkrun", "-o", "test"
    system "./test"
  end
end
