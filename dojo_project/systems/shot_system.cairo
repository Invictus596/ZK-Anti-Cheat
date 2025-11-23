%lang starknet

from starkware.starknet.common.syscalls import emit_event

@event
func ShotRegistered(player: felt, px: felt, py: felt, pz: felt,
                    dx: felt, dy: felt, dz: felt,
                    recoil: felt, damage: felt):
end

@event
func MovementRegistered(player: felt, px: felt, py: felt, pz: felt,
                        vx: felt, vy: felt, vz: felt):
end

@external
func register_shot(player: felt, px: felt, py: felt, pz: felt,
                   dx: felt, dy: felt, dz: felt,
                   recoil: felt, damage: felt):
    emit_event ShotRegistered(player, px, py, pz, dx, dy, dz, recoil, damage)
    return ()
end

@external
func register_movement(player: felt, px: felt, py: felt, pz: felt,
                       vx: felt, vy: felt, vz: felt):
    emit_event MovementRegistered(player, px, py, pz, vx, vy, vz)
    return ()
end
