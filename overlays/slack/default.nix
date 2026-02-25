{ prev }:
prev.slack.overrideAttrs (old: {
  postInstall = (old.postInstall or "") + ''
    wrapProgram $out/bin/slack \
      --add-flags "--disable-gpu" \
      --add-flags "--disable-gpu-compositing" \
      --add-flags "--use-gl=swiftshader"
  '';
})
