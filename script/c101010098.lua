--クリアー・ティラノー
function c101010098.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1160)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101010098.con)
	c:RegisterEffect(e1)
	--scale
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LSCALE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c101010098.slcon)
	e2:SetValue(6)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e3)
	--spell effect
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,101010098)
	e6:SetTarget(c101010098.tg)
	e6:SetOperation(c101010098.op)
	c:RegisterEffect(e6)
	--remove attribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c101010098.ratg)
	e5:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e5)
	--normal summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(101010098,0))
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_SUMMON_PROC)
	e7:SetCondition(c101010098.otcon)
	e7:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e7)
end
function c101010098.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsAttribute,tp,0,LOCATION_MZONE,1,nil,ATTRIBUTE_FIRE)
end
function c101010098.ratg(e)
	return e:GetHandler()
end
function c101010098.slcon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or (not tc:IsSetCard(0x306))
end
function c101010098.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101010098.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(ATTRIBUTE_WATER)
	tc:RegisterEffect(e5)
end
function c101010098.cfilter1(c)
	return Duel.IsExistingMatchingCard(c101010098.cfilter2,tp,0,LOCATION_MZONE,1,nil,c:GetOriginalAttribute())
end
function c101010098.cfilter2(c,att)
	return c:GetOriginalAttribute()~=att
end
function c101010098.otcon(e,c)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(c101010098.cfilter1,c:GetControler(),0,LOCATION_MZONE,nil)
	return c:GetLevel()>6 and g:GetCount()>1 and Duel.GetTributeCount(c)>0
end
