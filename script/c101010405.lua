--Spectrum Test
function c101010405.initial_effect(c)
	--Additional Effects here
	if not c101010405.global_check then
		c101010405.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetLabel(450)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010405.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010405.spectrum=true
c101010405.material=300
function c101010405.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,e:GetLabel())
	Duel.CreateToken(1-tp,e:GetLabel())
end
