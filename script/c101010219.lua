--Girl of Stellar Vine
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
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
ref.spatial=true
--Spatial Formula filter(s)
ref.material1=function(mc) return true end
-- ref.material2=function(mc) return true end -- Invert this block of code on Division Spatial Monsters (begin)
ref.divs_spatial=true --Division Procedure /
ref.stat=function(mc) return mc:GetAttack() or mc:GetDefence() or mc:GetAttack()-mc:GetDefence() end
ref.indicator=function(mc) return mc:GetLevel() or mc:GetRank() end -- Invert this block of code on Division Spatial Monsters (end)
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,450)
	Duel.CreateToken(1-tp,450)
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
