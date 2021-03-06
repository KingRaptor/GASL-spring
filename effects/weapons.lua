-- smallplasma
-- partillery
-- plasma
-- missile
-- laser
-- grav
-- kinetic
-- antimatter
-- graser
-- graser_blue
-- torpedo

return {
  ["smallplasma"] = {
    circle = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = 1,
        colormap           = [[1 1 1 1 .1   .3 .3 1 .1   0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 180,
        emitvector         = [[0,1,0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 26,
        particlelife       = 12,
        particlelifespread = 6,
        particlesize       = 10,
        particlesizespread = 5,
        particlespeed      = 2,
        particlespeedspread = 2,
        pos                = [[0, 1.0, 0]],
        sizegrowth         = 0.15,
        sizemod            = 0.5,
        texture            = [[smoke1]],
      },
    },
    ring1 = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        colormap           = [[1 1 1 .1   .5 .5 1 .1   0 0 0 0]],
        dir                = [[-1 r1, 1, -1 r1]],
        frontoffset        = 0,
        fronttexture       = [[shockwave]],
        length             = 1,
        pos                = [[0, 0, 0]],
        sidetexture        = [[null]],
        size               = 1,
        sizegrowth         = 30,
        ttl                = 18,
      },
    },
    spew = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = 1,
        colormap           = [[1 1 1 .1   0 0 0 0]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 120,
        emitvector         = [[0,1,0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 10,
        particlelife       = 24,
        particlelifespread = 12,
        particlesize       = 3,
        particlesizespread = 2,
        particlespeed      = 1,
        particlespeedspread = 5,
        pos                = [[0, 1.0, 0]],
        sizegrowth         = 0,
        sizemod            = 0.5,
        texture            = [[puff]],
      },
    },
  },

  ["partillery"] = {
    circle = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = 1,
        colormap           = [[1 1 1 1 .1   .3 .3 1 .1   0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 180,
        emitvector         = [[0,1,0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 26,
        particlelife       = 12,
        particlelifespread = 6,
        particlesize       = 20,
        particlesizespread = 10,
        particlespeed      = 4,
        particlespeedspread = 5,
        pos                = [[0, 1.0, 0]],
        sizegrowth         = 0.6,
        sizemod            = 1,
        texture            = [[smoke1]],
      },
    },
    ring1 = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        colormap           = [[1 1 1 .1   .5 .5 1 .1   0 0 0 0]],
        dir                = [[-1 r1, 1, -1 r1]],
        frontoffset        = 0,
        fronttexture       = [[shockwave]],
        length             = 1,
        pos                = [[0, 0, 0]],
        sidetexture        = [[null]],
        size               = 1,
        sizegrowth         = 175,
        ttl                = 18,
      },
    },
    spew = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = 1,
        colormap           = [[1 1 1 .1   0 0 0 0]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 120,
        emitvector         = [[0,1,0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 10,
        particlelife       = 24,
        particlelifespread = 12,
        particlesize       = 3,
        particlesizespread = 2,
        particlespeed      = 1,
        particlespeedspread = 5,
        pos                = [[0, 1.0, 0]],
        sizegrowth         = 0,
        sizemod            = 1,
        texture            = [[puff]],
      },
    },
  },

  ["plasma"] = {
    circle = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = 1,
        colormap           = [[1 1 1 1 .1   .3 .3 1 .1   0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 180,
        emitvector         = [[0,1,0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 26,
        particlelife       = 12,
        particlelifespread = 6,
        particlesize       = 10,
        particlesizespread = 5,
        particlespeed      = 2,
        particlespeedspread = 2,
        pos                = [[0, 1.0, 0]],
        sizegrowth         = 0.3,
        sizemod            = 1,
        texture            = [[smoke1]],
      },
    },
    ring1 = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        colormap           = [[1 1 1 .1   .5 .5 1 .1   0 0 0 0]],
        dir                = [[-1 r1, 1, -1 r1]],
        frontoffset        = 0,
        fronttexture       = [[shockwave]],
        length             = 1,
        pos                = [[0, 0, 0]],
        sidetexture        = [[null]],
        size               = 1,
        sizegrowth         = 60,
        ttl                = 18,
      },
    },
    spew = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = 1,
        colormap           = [[1 1 1 .1   0 0 0 0]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 120,
        emitvector         = [[0,1,0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 10,
        particlelife       = 24,
        particlelifespread = 12,
        particlesize       = 3,
        particlesizespread = 2,
        particlespeed      = 1,
        particlespeedspread = 5,
        pos                = [[0, 1.0, 0]],
        sizegrowth         = 0,
        sizemod            = 1,
        texture            = [[puff]],
      },
    },
  },

  ["missile"] = {
    circle = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = .8,
        colormap           = [[1 .9 .4 .1   .8 .3 0 .1   0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 180,
        emitvector         = [[0,1,0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 12,
        particlelife       = 16,
        particlelifespread = 8,
        particlesize       = 20,
        particlesizespread = 10,
        particlespeed      = 0,
        particlespeedspread = 2,
        pos                = [[0, 0, 0]],
        sizegrowth         = 1,
        sizemod            = .9,
        texture            = [[smoke1]],
      },
    },
    ring1 = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        colormap           = [[1 1 1 .1   .9 .5 .2 .1   0 0 0 0]],
        dir                = [[dir]],
        frontoffset        = 0,
        fronttexture       = [[shockwave]],
        length             = 1,
        pos                = [[0, 0, 0]],
        sidetexture        = [[null]],
        size               = 1,
        sizegrowth         = 40,
        ttl                = 9,
      },
    },
    spew = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = 1,
        colormap           = [[1 .9 .1 .1   .5 .3 0 .1   0 0 0 0]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 40,
        emitvector         = [[dir]],
        gravity            = [[0, 0, 0]],
        numparticles       = 5,
        particlelife       = 30,
        particlelifespread = 60,
        particlesize       = 3,
        particlesizespread = 2,
        particlespeed      = 3,
        particlespeedspread = 8,
        pos                = [[0, 1.0, 0]],
        sizegrowth         = 0,
        sizemod            = 1,
        texture            = [[puff]],
      },
    },
  },

  ["laser"] = {
    burst = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = 0.1,
        colormap           = [[1 1 1 .1   0 0 0 0]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 180,
        emitvector         = [[0,1,0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 1,
        particlelife       = 8,
        particlelifespread = 7,
        particlesize       = 1,
        particlesizespread = 0,
        particlespeed      = 0,
        particlespeedspread = .1,
        pos                = [[0, 0, 0]],
        sizegrowth         = 2,
        sizemod            = 1,
        texture            = [[firesplash]],
      },
    },
  },
  
  ["grav"] = {
    drag = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = 1,
        colormap           = [[1 .5 1 .1   0 0 0 0]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 120,
        emitvector         = [[0,1,0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 1,
        particlelife       = 8,
        particlelifespread = 3,
        particlesize       = 160,
        particlesizespread = 80,
        particlespeed      = .1,
        particlespeedspread = 0,
        pos                = [[0, 1.0, 0]],
        sizegrowth         = -16,
        sizemod            = 1,
        texture            = [[chargeparticles]],
      },
    },
    flash = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = 0,
        colormap           = [[0 0 0 .3   0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 180,
        emitvector         = [[0,1,0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 1,
        particlelife       = 15,
        particlelifespread = 8,
        particlesize       = 120,
        particlesizespread = 60,
        particlespeed      = 0,
        particlespeedspread = 0,
        pos                = [[0, 0, 0]],
        sizegrowth         = 1,
        sizemod            = 1,
        texture            = [[burncircle]],
      },
    },
  },

  ["kinetic"] = {
    flash = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = 0,
        colormap           = [[1 1 1 .1   0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 180,
        emitvector         = [[0,1,0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 1,
        particlelife       = 3,
        particlelifespread = 2,
        particlesize       = 5,
        particlesizespread = 8,
        particlespeed      = 0,
        particlespeedspread = 0,
        pos                = [[0, 0, 0]],
        sizegrowth         = 1,
        sizemod            = 1,
        texture            = [[burncircle]],
      },
    },
    spew = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = 1,
        colormap           = [[1 .9 .1 .1   .5 .3 0 .1   0 0 0 0]],
        directional        = true,
        emitrot            = 140,
        emitrotspread      = 40,
        emitvector         = [[dir]],
        gravity            = [[0, 0, 0]],
        numparticles       = 2,
        particlelife       = 5,
        particlelifespread = 6,
        particlesize       = 3,
        particlesizespread = 2,
        particlespeed      = 1,
        particlespeedspread = 1,
        pos                = [[0, 1.0, 0]],
        sizegrowth         = 0,
        sizemod            = 1,
        texture            = [[puff]],
      },
    },
  },

  ["antimatter"] = {
    rays = {
      air                = true,
      class              = [[explspike]],
      count              = 15,
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        alpha              = 0.9,
        alphadecay         = 0.1,
        color              = [[1, 1, 1]],
        dir                = [[-1 r2, 0 r1, -1 r2]],
        length             = 130,
        width              = 6,
      },
    },
  },

  ["graser"] = {
    rays = {
      air                = true,
      class              = [[explspike]],
      count              = 15,
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        alpha              = 0.9,
        alphadecay         = 0.1,
        color              = [[0.3, 1, 0.3]],
        dir                = [[-1 r2, 0 r1, -1 r2]],
        length             = 90,
        width              = 4,
      },
    },
  },

  ["graser_blue"] = {
    rays = {
      air                = true,
      class              = [[explspike]],
      count              = 15,
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        alpha              = 0.9,
        alphadecay         = 0.1,
        color              = [[0.3, 0.3, 1]],
        dir                = [[-1 r2, 0 r1, -1 r2]],
        length             = 105,
        width              = 5,
      },
    },
  },    

  ["graser_pink"] = {
    rays = {
      air                = true,
      class              = [[explspike]],
      count              = 15,
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        alpha              = 0.9,
        alphadecay         = 0.1,
        color              = [[1,0.2,0.8]],
        dir                = [[-1 r2, 0 r1, -1 r2]],
        length             = 105,
        width              = 5,
      },
    },
  },    
  
  ["torpedo"] = {
    circle = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = .8,
        colormap           = [[1 .9 .4 .1   .8 .3 0 .1   0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 180,
        emitvector         = [[0,1,0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 12,
        particlelife       = 30,
        particlelifespread = 16,
        particlesize       = 20,
        particlesizespread = 10,
        particlespeed      = 0,
        particlespeedspread = 5,
        pos                = [[0, 0, 0]],
        sizegrowth         = 3,
        sizemod            = .9,
        texture            = [[smoke1]],
      },
    },
    shockwave = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = 0,
        colormap           = [[1 1 1 .1   1 1 1 .1   0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 0,
        emitvector         = [[0,1,0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 1,
        particlelife       = 40,
        particlelifespread = 20,
        particlesize       = 1,
        particlesizespread = 0,
        particlespeed      = 0,
        particlespeedspread = 0,
        pos                = [[0, 0, 0]],
        sizegrowth         = 4,
        sizemod            = 1,
        texture            = [[shockwave]],
      },
    },
    spew = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      ground             = true,
      water              = true,
      underwater    = true,
      properties = {
        airdrag            = 1,
        colormap           = [[1 .9 .1 .1   .5 .3 0 .1   0 0 0 0]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 140,
        emitvector         = [[0,1,0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 10,
        particlelife       = 120,
        particlelifespread = 60,
        particlesize       = 1,
        particlesizespread = 1,
        particlespeed      = 3,
        particlespeedspread = 8,
        pos                = [[0, 1.0, 0]],
        sizegrowth         = 0,
        sizemod            = 1,
        texture            = [[puff]],
      },
    },
  },

  ["cannon_muzzle"] = {
    bitmapmuzzleflame = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true,
      properties = {
        colormap           = [[1 1 0.5 0.01	1 0.7 0 0.01	0 0 0 0.01]],
        dir                = [[dir]],
        frontoffset        = 0.3,
        fronttexture       = [[plasma0029]],
        length             = 1,
        sidetexture        = [[plasma2]],
        size               = 0.5,
        sizegrowth         = 70,
        ttl                = 5,
      },
    },
    bitmapmuzzleflame2 = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true,
      properties = {
        colormap           = [[1 1 0 0.01	1 0.5 0 0.01	0 0 0 0.01]],
        dir                = [[dir]],
        frontoffset        = -0.1,
        fronttexture       = [[flowerflash]],
        length             = 0.1,
        sidetexture        = [[plasma2]],
        size               = 20,
        sizegrowth         = 1,
        ttl                = 3,
      },
    },
    muzzleflash = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.90,
        colormap           = [[1 0.7 0.2 0.01    1 0.7 0.2 0.01    0 0 0 0.01]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 10,
        emitvector         = [[dir]],
        gravity            = [[0, 0, 0]],
        numparticles       = 5,
        particlelife       = 18,
        particlelifespread = 5,
        particlesize       = 1,
        particlesizespread = 0.3,
        particlespeed      = 2,
        particlespeedspread = 4,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1.0,
        texture            = [[plasma]],
      },
    },
    muzzlesmoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 10,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.8,
        colormap           = [[0 0 0 0.01  0.5 0.5 0.5 0.5     0 0 0 0.01]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 10,
        emitvector         = [[dir]],
        gravity            = [[0, 0.2, 0]],
        numparticles       = 1,
        particlelife       = 5,
        particlelifespread = 0,
        particlesize       = [[7 i-0.4]],
        particlesizespread = 1,
        particlespeed      = [[10 i-1]],
        particlespeedspread = 1,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1.0,
        texture            = [[smokesmall]],
      },
    },
  },
}

