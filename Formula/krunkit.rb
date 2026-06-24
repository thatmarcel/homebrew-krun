class Krunkit < Formula
  desc "CLI tool to start Linux KVM or macOS HVF VMs using the libkrun"
  homepage "https://github.com/containers/krunkit"
  url "https://github.com/containers/krunkit/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "355e73e42bc2f1d1087e15f417545646a03d020d332c319905e95d7849ef83f2"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/libkrun/homebrew-krun/releases/download/krunkit-1.2.2"
    sha256 cellar: :any, arm64_tahoe:   "75111e280a29977651dc8d82895ac43dc0c74158f4df503647ee21fa776e432c"
    sha256 cellar: :any, arm64_sequoia: "e432542c6ae3ba0014391542cdebd21edc1f930eab20512aa0d628bb213cf997"
  end

  depends_on "rust" => :build
  # We depend on libkrun, which only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "gvproxy"
  depends_on "libkrun"

  def install
    homebrew_lib = ENV["HOMEBREW_PREFIX"] + "/lib"
    system "make"
    MachO::Tools.add_rpath("target/release/krunkit", homebrew_lib)
    system "codesign", "--entitlements", "krunkit.entitlements", "--force", "-s", "-", "target/release/krunkit"
    bin.install "target/release/krunkit"
    pkgshare.install "edk2/KRUN_EFI.silent.fd"
  end

  test do
    system "#{bin}/krunkit", "--version"
  end
end
