module sector(radius, start_degree, end_degree) {
    polygon(
        concat([[0, 0]],
        [for(angle = [start_degree:1:end_degree]) [radius * cos(angle), radius * sin(angle)]]
    ));
}
