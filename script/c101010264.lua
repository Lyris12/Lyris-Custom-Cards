--カオス・クローク
local id,ref=GIR()
function ref.start(c)
--equip(Negate)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(ref.condition)
	e0:SetTarget(ref.target)
	e0:SetOperation(ref.activate)
	c:RegisterEffect(e0)
	--Once per turn, you can either: Target 1 LIGHT or DARK monster you control; equip this card to that target, 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(ref.eqtg)
	e1:SetOperation(ref.eqop)
	c:RegisterEffect(e1)
	--OR: Unequip this card and Special Summon it in face-up Attack Position.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(ref.uncon)
	e2:SetTarget(ref.sptg)
	e2:SetOperation(ref.spop)
	c:RegisterEffect(e2)
	--While equipped to a monster, LIGHT and DARK monsters you control are unaffected by your opponent's Counter Traps.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(ref.uncon)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,0x30))
	e3:SetValue(ref.efilter)
	c:RegisterEffect(e3)
	--While face-up on the field, this card is also LIGHT-Attribute.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetTarget(ref.atcon)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_ADD_ATTRIBUTE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e4)
	--destroy sub
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e5:SetCondition(ref.uncon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--eqlimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(ref.eqlimit)
	c:RegisterEffect(e6)
end
function ref.atcon(e,c)
	return c==e:GetHandler()
end
function ref.eqlimit(e,c)
	return c:IsAttribute(0x30)
end
function ref.uncon(e)
	return e:GetHandler():IsStatus(STATUS_UNION)
end
function ref.filter(c)
	return c:IsAttribute(0x30) and c:IsFaceup() and c:IsDestructable()
end
function ref.filter2(c)
	return c:IsAttribute(0x30) and c:IsFaceup() and c:GetUnionCount()==0
end
function ref.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_DISABLE_SUMMON)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(id)==0
	and Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_MZONE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_CARD,tp,id)
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
		else return false
	end
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		Duel.SendtoGrave(e:GetHandler(),REASON_COST) return
	end
	local g=Duel.SelectMatchingCard(tp,ref.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	if not Duel.Equip(tp,e:GetHandler(),g:GetFirst(),true) then return end
	e:GetHandler():SetStatus(STATUS_UNION,true)
	Duel.ChangeChainOperation(ev,ref.repop)
end
function ref.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil):RandomSelect(tp,1)
	Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
end
function ref.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and ref.filter2(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(id)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	and Duel.IsExistingTarget(ref.filter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,ref.filter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function ref.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not ref.filter2(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	c:SetStatus(STATUS_UNION,true)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(id)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end
function ref.efilter(e,tp,re,r,rp,te)
	return te:IsActiveType(TYPE_COUNTER) and rp~=tp and te:GetHandler()~=e:GetHandler()
end