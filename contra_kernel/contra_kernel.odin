// contra_raylib.odin
package main

import "core:fmt"
import "vendor:raylib"

Vec2 :: struct { x, y: i32 }

Entity_Kind :: enum {
    Player,
    Enemy,
    Bullet,
}

Entity :: struct {
    kind : Entity_Kind,
    pos  : Vec2,
    vel  : Vec2,
    hp   : int,
    alive: bool
}

max_entities :: 128
entities : [max_entities]Entity
entity_count : int

spawn_entity :: proc(kind: Entity_Kind, pos, vel: Vec2, hp: int) {
    if entity_count >= max_entities { return }
    e := &entities[entity_count]
    e.kind = kind
    e.pos = pos
    e.vel = vel
    e.hp = hp
    e.alive = true
    entity_count += 1
}

enemy_patrol_update :: proc(e: ^Entity) {
    e.pos.x += e.vel.x
    if e.pos.x < 20 || e.pos.x > 380 do e.vel.x = -e.vel.x
}

player_update :: proc(e: ^Entity) {
    // physics :
    if e.pos.y < 120 do e.pos.y += 1
    
    // input handling :
    if raylib.IsKeyDown(raylib.KeyboardKey.RIGHT) do e.pos.x += 2
    if raylib.IsKeyDown(raylib.KeyboardKey.LEFT) do e.pos.x -= 2
    if raylib.IsKeyPressed(raylib.KeyboardKey.UP) do e.pos.y -= 20
    if raylib.IsKeyPressed(raylib.KeyboardKey.SPACE) {
        spawn_entity(.Bullet, Vec2{e.pos.x + 8, e.pos.y}, Vec2{4, 0}, 1)
    }
}

bullet_update :: proc(e: ^Entity) {
    e.pos.x += e.vel.x
    if e.pos.x > 400 do e.alive = false
}

update_entities :: proc() {
    for i in 0..<entity_count {
        e := &entities[i]
        if !e.alive { continue }
        switch e.kind {
        case .Player: player_update(e)
        case .Enemy:  enemy_patrol_update(e)
        case .Bullet: bullet_update(e)
        }
    }

    // Cull dead
    i := 0
    for i < entity_count {
        if entities[i].alive {
            i += 1
        } else {
            entities[i] = entities[entity_count-1]
            entity_count -= 1
        }
    }
}

render_entities :: proc() {
    for i in 0..<entity_count {
        e := entities[i]
        color := raylib.WHITE
        switch e.kind {
        case .Player: color = raylib.Color{0, 200, 255, 255}
        case .Enemy:  color = raylib.Color{255, 0, 0, 255}
        case .Bullet: color = raylib.Color{255, 255, 0, 255}
        }
        raylib.DrawRectangle(e.pos.x, e.pos.y, 8, 8, color)
    }
}

main :: proc() {
    raylib.InitWindow(400, 240, "Contra Kernel - Odin + Raylib")
    defer raylib.CloseWindow()
    raylib.SetTargetFPS(60)

    spawn_entity(.Player, Vec2{40, 120}, Vec2{0, 0}, 3)
    spawn_entity(.Enemy, Vec2{300, 120}, Vec2{-1, 0}, 3)

    for !raylib.WindowShouldClose() {
        update_entities()

        raylib.BeginDrawing()
        raylib.ClearBackground(raylib.BLACK)
        render_entities()
        raylib.EndDrawing()
    }
}
