#!/usr/bin/env python3
"""
ASCOT5 Benchmark 1: Alpha Particle Slowing-Down
"""
import numpy as np
from a5py import Ascot

print("=" * 70)
print("ASCOT5 Benchmark 1 Setup")
print("=" * 70)

# Configuration
n_markers = 8000
print(f"Markers: {n_markers:,}")
print("=" * 70)

# Create HDF5 file
print("\nCreating HDF5 file...")
a5 = Ascot("benchmark1.h5", create=True)

# Set up analytical tokamak magnetic field
print("Creating magnetic field (analytical ITER-like)...")
a5.data.create_input("bfield analytical iter circular")

# Set up plasma: density = 1e21 m^-3, temperature = 10 keV
print("Creating plasma profiles...")
a5.data.create_input("plasma flat", density=1e21)

# Wall geometry
print("Creating wall geometry...")
a5.data.create_input("wall_2D")

# Electric field (zero)
print("Creating electric field...")
a5.data.create_input("E_TC", exyz=np.array([0,0,0]))

# Required dummy inputs
print("Creating auxiliary inputs...")
a5.data.create_input("N0_1D")
a5.data.create_input("Boozer")
a5.data.create_input("MHD_STAT")
a5.data.create_input("asigma_loc")

# Create alpha particle markers
print(f"\nGenerating {n_markers:,} alpha particle markers...")
from a5py.ascot5io.marker import Marker

# Set random seed for reproducibility
np.random.seed(12345)

mrk = Marker.generate("gc", n=n_markers, species="alpha")

# Initial conditions: 3.5 MeV alpha particles (fusion-born)
mrk["energy"][:] = 3.5e6  # 3.5 MeV
mrk["pitch"][:] = 0.99 - 1.98 * np.random.rand(n_markers)  # Pitch: -0.99 to 0.99
mrk["r"][:] = 4.5 + 3.0 * np.random.rand(n_markers)  # R: 4.5 to 7.5 m
mrk["z"][:] = -1.5 + 3.0 * np.random.rand(n_markers)  # Z: -1.5 to 1.5 m  
mrk["phi"][:] = 360.0 * np.random.rand(n_markers)  # phi: 0 to 360 degrees

a5.data.create_input("gc", **mrk)

# Configure simulation options
print("Configuring simulation options...")
from a5py.ascot5io.options import Opt
opt = Opt.get_default()

opt.update({
    # Simulation mode
    "SIM_MODE": 2,  # Guiding center
    "ENABLE_ADAPTIVE": 1,  # Adaptive time-step
    "ENABLE_ORBIT_FOLLOWING": 1,
    
    # CRITICAL: Enable Coulomb collisions for realistic slowing-down
    "ENABLE_COULOMB_COLLISIONS": 1,
    
    # End conditions
    "ENDCOND_ENERGYLIM": 1,
    "ENDCOND_MIN_ENERGY": 2.0e3,  # Stop at 2 keV
    "ENDCOND_MIN_THERMAL": 2.0,  # Or 2× thermal energy
    "ENDCOND_SIMTIMELIM": 1,
    "ENDCOND_LIM_SIMTIME": 1.0,  # Max 1 second simulation time
    
    # Distribution collection
    "ENABLE_DIST_5D": 1,
    "ENABLE_DIST_RHO5D": 1,
    
    # 5D distribution grid (R, phi, z, ppar, pperp)
    "DIST_MIN_R": 4.3,
    "DIST_MAX_R": 8.3,
    "DIST_NBIN_R": 50,
    
    "DIST_MIN_Z": -2.0,
    "DIST_MAX_Z": 2.0,
    "DIST_NBIN_Z": 50,
    
    "DIST_MIN_PHI": 0,
    "DIST_MAX_PHI": 360,
    "DIST_NBIN_PHI": 1,
    
    "DIST_MIN_PPA": -1.3e-19,
    "DIST_MAX_PPA": 1.3e-19,
    "DIST_NBIN_PPA": 100,
    
    "DIST_MIN_PPE": 0,
    "DIST_MAX_PPE": 1.3e-19,
    "DIST_NBIN_PPE": 50,
    
    # rho5D distribution grid (rho, theta, phi, ppar, pperp)
    "DIST_MIN_RHO": 0,
    "DIST_MAX_RHO": 1.0,
    "DIST_NBIN_RHO": 100,
    
    "DIST_MIN_THETA": 0,
    "DIST_MAX_THETA": 360,
    "DIST_NBIN_THETA": 1,
    
    # Time and charge
    "DIST_MIN_TIME": 0,
    "DIST_MAX_TIME": 1.0,
    "DIST_NBIN_TIME": 1,
    
    "DIST_MIN_CHARGE": 1,
    "DIST_MAX_CHARGE": 3,
    "DIST_NBIN_CHARGE": 1,
    
    # Disable orbit writing for performance
    "ENABLE_ORBITWRITE": 0,
})

a5.data.create_input("opt", **opt, desc="Benchmark1")

print("\n" + "=" * 70)
print("Setup Complete!")
print("=" * 70)
print("\nConfiguration Summary:")
print(f"  File: benchmark1.h5")
print(f"  Markers: {n_markers:,}")
print(f"  Species: Alpha particles (He-4, Z=2)")
print(f"  Initial energy: 3.5 MeV")
print(f"  Plasma density: 1e21 m^-3")
print(f"  Plasma temperature: 10 keV")
print(f"  Physics: Coulomb collisions enabled")
print(f"  End condition: Thermalization to ~2 keV")
print(f"  Distributions: 5D (50×50×100×50) + rho5D (100)")
print("=" * 70)