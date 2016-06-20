--スターライト・クェーサー・ドラゴン
local id,ref=GIR()
function ref.start(c)
--summon condition
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE)
	ae1:SetRange(LOCATION_EXTRA)
	ae1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ae1:SetCode(EFFECT_SPSUMMON_CONDITION)
	ae1:SetValue(ref.slimit)
	c:RegisterEffect(ae1)
	--attribute
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_FIELD)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetTargetRange(LOCATION_MZONE,0)
	ae2:SetTarget(ref.atcon)
	ae2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	ae2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(ae2)
	--cripple monster
	local ae3=Effect.CreateEffect(c)
	ae3:SetType(EFFECT_TYPE_FIELD)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ae3:SetCode(EFFECT_UPDATE_ATTACK)
	ae3:SetCondition(ref.condition)
	ae3:SetTarget(ref.dtarget)
	ae3:SetValue(ref.adval)
	c:RegisterEffect(ae3)
	local ae4=Effect.CreateEffect(c)
	ae4:SetType(EFFECT_TYPE_FIELD)
	ae4:SetRange(LOCATION_MZONE)
	ae4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	ae4:SetCode(EFFECT_UPDATE_DEFENCE)
	ae4:SetCondition(ref.condition)
	ae4:SetTarget(ref.dtarget)
	ae4:SetValue(ref.ddval)
	c:RegisterEffect(ae4)
	--negate spell/trap
	local ae5=Effect.CreateEffect(c)
	ae5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	ae5:SetCode(EVENT_EQUIP)
	ae5:SetOperation(ref.regop)
	c:RegisterEffect(ae5)
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(ref.spcon)
	e1:SetOperation(ref.spop)
	e1:SetValue(SUMMON_TYPE_XYZ+0x7150)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(function(e,se,ep,st) return bit.band(st,SUMMON_TYPE_XYZ+0x7150)==SUMMON_TYPE_XYZ+0x7150 end)
	c:RegisterEffect(e2)
	--cannot Grave (Do Not Remove)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ge1:SetTargetRange(LOCATION_ONFIELD+LOCATION_OVERLAY,0)
	ge1:SetTarget(function(e,c) return c==e:GetHandler() end)
	ge1:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(ge1,0)
end
function ref.spfilter(c,v,y,z)
	local atk=c:GetAttack()
	return c:GetRank()==v and atk>=y and atk<=z and c:IsAbleToRemoveAsCost()
end
function ref.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_MZONE,0,1,nil,4,2100,2700)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(ref.spfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc1=g:Select(tp,1,1,nil)
	c:SetMaterial(tc1)
	local fg=tc1:Filter(Card.IsFacedown,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	Duel.Remove(tc1,POS_FACEUP,REASON_MATERIAL+0x7150)
end
function ref.atcon(e,c)
	return c==e:GetHandler()
end
function ref.slimit(e,se,sp,st)
	return bit.band(st,0x7150)==0x7150
end
function ref.condition(e)
	return bit.band(e:GetHandler():GetSummonType(),0x7150)==0x7150
end
function ref.dtarget(e,c)
	return c:IsFaceup() and not c:IsRace(RACE_DRAGON+RACE_WYRM)
end
function ref.adval(e,c)
	return -c:GetBaseAttack()/4
end
function ref.ddval(e,c)
	return -c:GetBaseDefence()/4
end
function ref.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(201010257)==0 then
		--Banish any face-up Continuous cards on the field.
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetCondition(ref.con)
		e1:SetOperation(ref.desop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EVENT_ADJUST)
		c:RegisterEffect(e2)
		--Negate the effects of all Normal Traps and Quick-Play Spells (anywhere).
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
		e3:SetCondition(ref.con)
		e3:SetTarget(ref.efilter)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(201010257,RESET_EVENT+0x1fe0000,0,1)
	end
end
function ref.con(e)
	return e:GetHandler():GetEquipCount()>0
end
function ref.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function ref.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local tc=g:GetFirst()
	while tc do
		if ref.desfilter(tc) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		tc=g:GetNext()
	end
end
function ref.efilter(e,c)
	return c:GetType()==TYPE_TRAP or c:IsType(TYPE_QUICKPLAY)
end
