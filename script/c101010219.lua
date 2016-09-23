--スターライト・クェーサー・ドラゴン
function c101010219.initial_effect(c)
	--[[summon condition
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetRange(LOCATION_EXTRA)
	ae1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ae1:SetCode(EFFECT_SPSUMMON_CONDITION)
	ae1:SetValue(c101010219.slimit)
	c:RegisterEffect(ae1)]]
	--attribute
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_SINGLE)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	ae2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(ae2)
	--cripple monster
	local ae3=Effect.CreateEffect(c)
	ae3:SetType(EFFECT_TYPE_FIELD)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ae3:SetCode(EFFECT_UPDATE_ATTACK)
	ae3:SetCondition(c101010219.condition)
	ae3:SetTarget(c101010219.dtarget)
	ae3:SetValue(c101010219.adval)
	c:RegisterEffect(ae3)
	local ae4=Effect.CreateEffect(c)
	ae4:SetType(EFFECT_TYPE_FIELD)
	ae4:SetRange(LOCATION_MZONE)
	ae4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ae4:SetCode(EFFECT_UPDATE_DEFENSE)
	ae4:SetCondition(c101010219.condition)
	ae4:SetTarget(c101010219.dtarget)
	ae4:SetValue(c101010219.ddval)
	c:RegisterEffect(ae4)
	--negate spell/trap
	local ae5=Effect.CreateEffect(c)
	ae5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	ae5:SetCode(EVENT_EQUIP)
	ae5:SetCountLimit(1)
	ae5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_NO_TURN_RESET)
	ae5:SetOperation(c101010219.regop)
	c:RegisterEffect(ae5)
	if not c101010219.global_check then
		c101010219.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010219.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010219.spatial=true
function c101010219.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,500)
	Duel.CreateToken(1-tp,500)
end
--[[function c101010219.slimit(e,se,sp,st)
	return bit.band(st,0x7150)==0x7150
end]]
function c101010219.condition(e)
	return bit.band(e:GetHandler():GetSummonType(),0x7150)==0x7150
end
function c101010219.dtarget(e,c)
	return c:IsFaceup() and not c:IsRace(RACE_DRAGON+RACE_WYRM)
end
function c101010219.adval(e,c)
	return -c:GetBaseAttack()/4
end
function c101010219.ddval(e,c)
	return -c:GetBaseDefense()/4
end
function c101010219.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(101010257)==0 then
		--During the End Phase, banish all face-up Continuous cards on the field.
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCondition(c101010219.con)
		e1:SetOperation(c101010219.desop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		--Negate the effects of all Normal Traps and Quick-Play Spells (anywhere).
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
		e3:SetCondition(c101010219.con)
		e3:SetTarget(c101010219.efilter)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(101010257,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c101010219.con(e)
	return e:GetHandler():GetEquipCount()>0
end
function c101010219.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function c101010219.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c101010219.efilter(e,c)
	return c:GetType()==TYPE_TRAP or c:IsType(TYPE_QUICKPLAY)
end
