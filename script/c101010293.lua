--Sea Scout of Stellar Vine
function c101010293.initial_effect(c)
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae1:SetCode(EFFECT_ADD_TYPE)
	ae1:SetValue(TYPE_SYNCHRO)
	ae1:SetCondition(c101010293.atcon)
	c:RegisterEffect(ae1)
	--boost
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_FIELD)
	ae2:SetCode(EFFECT_UPDATE_ATTACK)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetTargetRange(LOCATION_MZONE,0)
	ae2:SetTarget(c101010293.syntg)
	ae2:SetValue(1000)
	c:RegisterEffect(ae2)
	if not spatial_check then
		spatial_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010293.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010293.spatial=true
c101010293.alterf=	function(mc)
				return bit.band(mc:GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO and mc:GetMaterial():IsExists(Card.IsType,1,nil,TYPE_TUNER)
			end
function c101010293.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,500)
	Duel.CreateToken(1-tp,500)
end
function c101010293.atcon(e,tp)
	return Duel.GetTurnPlayer()==tp
end
function c101010293.syntg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c~=e:GetHandler()
end
