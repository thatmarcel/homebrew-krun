class Krunai < Formula
  desc "CLI tool for running AI agents inside microVM sandboxes"
  homepage "https://github.com/slp/krunai"
  url "https://github.com/slp/krunai/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "de8612266621144b0234bce27ac8b615b662c8f7b0c7eef81805d780805b10d4"
  license "Apache-2.0"

  bottle do
    root_url "https://raw.githubusercontent.com/slp/homebrew-krun/master/bottles"
    sha256 cellar: :any, arm64_tahoe:   "5a21196fcc559402eb28d5b678ea84a8ab17ee0d79a3bdcacf5362f41fb8f745"
    sha256 cellar: :any, arm64_sequoia: "a36843adbfa37de7ce4646d4573d260566810b6513aee9f474e25c637c95cf63"
  end

  depends_on "rust" => :build
  # We depend on libkrun, which only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "gvproxy"
  depends_on "libkrun"
  # We just need qemu-img, but it's not packaged independently
  depends_on "qemu"

  def install
    homebrew_lib = ENV["HOMEBREW_PREFIX"] + "/lib"
    system "make"
    MachO::Tools.add_rpath("target/release/krunai", homebrew_lib)
    system "codesign", "--entitlements", "krunai.entitlements", "--force", "-s", "-", "target/release/krunai"
    bin.install "target/release/krunai"
  end

  test do
    system "#{bin}/krunai", "--version"
  end
end
