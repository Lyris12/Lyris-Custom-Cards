--キメラテック・ストロングホールド・ドラゴンЯ
local id,ref=GIR()
function ref.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,79229522,ref.material,1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(ref.spclimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(ref.sprcon)
	e2:SetOperation(ref.sprop)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(ref.splimit)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCondition(ref.atkcon)
	e4:SetOperation(ref.atkop)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(ref.atkuop)
	c:RegisterEffect(e5)
end
function ref.material(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x5d)
end
function ref.spclimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function ref.spfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x5d) and c:IsAbleToGraveAsCost()
end
function ref.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,79229522) and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,c,tp)
end
function ref.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010047,0))
	local g1=Duel.SelectReleaseGroup(c:GetControler(),Card.IsCode,1,1,nil,79229522)
	local kt=g1:GetFirst()
	local atk=kt:GetBaseAttack()/1000
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010047,1))
	local g2=Duel.SelectMatchingCard(tp,ref.spfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,1,nil,tp,ft)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
	--set attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0xfe0000)
	e1:SetValue(atk*400)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENCE)
	c:RegisterEffect(e2)
end
function ref.splimit(e,c)
	return c:IsCode(79229522) and c:GetLocation()==LOCATION_EXTRA
end
function ref.atkcon(e)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil
end
function ref.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(ref.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function ref.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function ref.atkuop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(c:GetBaseAttack()*3)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
