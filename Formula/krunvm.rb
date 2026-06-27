class Krunvm < Formula
  desc "Manage lightweight VMs created from OCI images"
  homepage "https://github.com/slp/krunvm"
  url "https://github.com/containers/krunvm/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "9f13e938a10565cdd0d38bd49f8c7fc5be57245740bad2bb138eec8675d4ee3b"
  license "Apache-2.0"

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build
  # We depend on libkrun, which only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "libkrun/krun/buildah"
  depends_on "thatmarcel/krun/libkrun"

  def install
    system "make"
    bin.install "target/release/krunvm"
    man1.install Dir["target/release/build/krunvm-*/out/*.1"]
  end

  test do
    system "#{bin}/krunvm", "--version"
  end
end
