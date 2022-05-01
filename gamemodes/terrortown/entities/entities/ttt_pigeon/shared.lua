ENT.Type = "anim"
ENT.Model = Model( "models/pigeon.mdl" )
i = 0

function ENT:Initialize()
	i = 0
	self:SetModel( self.Model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetModelScale(2,0.01)

	if( SERVER ) then
	
		sound.Add( {
		name = "habicht",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 100,
		pitch = 100,
		sound = "vogel/sound.wav"
		} )
		
		self:EmitSound( Sound( "habicht", 500 ) )

		self:SetHealth(1)
		self:SetMaxHealth(1)
		self:GetPhysicsObject():SetMass( 1 )
	end

	if( CLIENT ) then
      self:EmitSound( Sound( "habicht", 100 ) )
	end
end


function ENT:Think()
	if ( SERVER ) then
		i = i + 1

		delay = 7

		if ( i == delay ) then
			self:GetPhysicsObject():ApplyForceCenter( ( self.Target:GetShootPos() - self:GetPos() ) * Vector( 3, 3, 3 ) )
		end

		if( i >= delay ) then
			if( IsValid( self.Target ) ) then
				local Mul = 3
				if( self:GetPos():Distance( self.Target:GetPos() ) < 200 ) then Mul = 15 end
				self:GetPhysicsObject():ApplyForceCenter( ( self.Target:GetShootPos() - self:GetPos() ) * Vector( Mul, Mul, Mul ) )
				self:SetAngles( ( ( self.Target:GetShootPos() - self:GetPos() ) * Vector( Mul, Mul, Mul ) ):Angle() )

				if( !self.Target:Alive() ) then
					self:Remove()
				end
			else
				self:Remove()
			end
		end
	end
end
