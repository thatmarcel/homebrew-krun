class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/libkrun/libkrun"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.19.3.tar.gz"
  sha256 "955b0d948f1d1cf315c55ea92b55d5251928e6ec6f6aa6697cea95afccd4d2b0"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/thatmarcel/homebrew-krun/releases/download/libkrun-1.19.3"
    sha256 cellar: :any, arm64_tahoe:   "1407b421ed98747334285a135f6bdb8e42daf6beac7076b2cfce1fb017e8179a"
    sha256 cellar: :any, arm64_sequoia: "9bc73f8793f38fe2cc68c161dbf93f7abc5a5f9cc87da926d2cd8c2427de5f3a"
  end

  depends_on "lld" => :build
  depends_on "rust" => :build
  # Upstream only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "dtc"
  depends_on "libepoxy"
  depends_on "thatmarcel/krun/libkrunfw"
  depends_on "thatmarcel/krun/virglrenderer"
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
