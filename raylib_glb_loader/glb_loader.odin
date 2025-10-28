package main

import "core:fmt"
import "core:strings"
import "vendor:raylib"

asset_path :: proc(asset: string) -> cstring {
    exe_path := raylib.GetApplicationDirectory()
    return_path := fmt.tprintf("%s%s", exe_path, asset)
    fmt.printfln("%s", return_path)
    return strings.clone_to_cstring(return_path)
}

main :: proc (){
    // =============================
    // CONFIG 
    // =============================
    using raylib // namespace but only locally
    screen_width  :i32 = 800
    screen_height :i32 = 450
    InitWindow(
        screen_width, 
        screen_height, 
        "raylib on Odin")
    defer CloseWindow()

    // Camera
    camera: Camera = {}
    camera.position = Vector3 { 6.0, 6.0, 6.0 }      // Camera position
    camera.target = Vector3 { 0.0, 2.0, 0.0 }        // Camera looking at point
    camera.up = Vector3 { 0.0, 1.0, 0.0 }            // Camera up vector (rotation towards target)
    camera.fovy = 45.0                               // Camera field-of-view Y
    camera.projection = CameraProjection.PERSPECTIVE // Camera projection type

    // Load gltf model
    robot_path := asset_path("robot.glb")
    model := LoadModel(robot_path)
    position := Vector3 {0.0, 0.0, 0.0}
    
    // Load gltf anim
    anim_count : i32 = 0
    anim_index : i32 = 0
    anim_current_frame : i32 = 0
    model_animations := LoadModelAnimations(robot_path, &anim_count)
    // FPS config 
    SetTargetFPS(60)

    // =============================
    // RUNTIME
    // =============================
    // Odin doesn't have while keyword :
    for !WindowShouldClose() {
        // =============================
        // LOGIC 
        // =============================
        // Update Camera
        UpdateCamera(&camera, CameraMode.ORBITAL)
        // Select current animation 
        if IsMouseButtonPressed(MouseButton.RIGHT) {
            anim_index = (anim_index + 1) % anim_count
        } 
        if IsMouseButtonPressed(MouseButton.LEFT) {
            anim_index = (anim_index + anim_count - 1) % anim_count
        }
        // Update model animation 
        anim := model_animations[anim_index]
        anim_current_frame = (anim_current_frame +1) % anim.frameCount
        UpdateModelAnimation(model, anim, anim_current_frame)
        // =============================
        // Draw 
        // =============================
        BeginDrawing()
            ClearBackground(RAYWHITE)
            BeginMode3D(camera)
                DrawModel(model, position, 1.0, WHITE)
                DrawGrid(10, 1.0)
            EndMode3D()
            DrawText("Use the LEFT/RIGHT mouse buttons to switch animation", 10, 10, 20, GRAY)
            DrawText(TextFormat("Animation: %s", anim.name), 10, GetScreenHeight() - 20, 10, DARKGRAY)
        EndDrawing()
        //=============================================================
    }
    // Unload model/mesh/material
    UnloadModel(model)
}