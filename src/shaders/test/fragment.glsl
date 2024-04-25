 uniform vec2 mousePos;
void main() {
    float dist = distance(gl_FragCoord.xy, mousePos);
    if (dist < 0.1) {
    // Logika ucieczki
    }
    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}