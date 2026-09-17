-- Keep Walker instant when it opens as an overlay.
hl.layer_rule({
    name = "no-anim-walker",
    match = { namespace = "walker" },
    no_anim = true,
})
